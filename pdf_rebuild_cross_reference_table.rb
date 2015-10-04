require 'bundler/setup'
Bundler.require

class PdfRebuildCrossReferenceTable
  attr_reader :filename, :pdf_content

  def log(msg)
  end

  def initialize(pdf_filename)
    @filename = pdf_filename
    @pdf_content = nil
    @override = (ENV['PDF_REBUILD_CROSS_REFERENCE_TABLE_NO_PROMPT'] and ENV['PDF_REBUILD_CROSS_REFERENCE_TABLE_NO_PROMPT'] == "true")
  end

  def get_pdf_content
    File.binread(filename)
  end

  def mk_backup
    `cp #{filename} #{filename}.bak`
  end

  def generate_cross_reference_table
    i = 1
    obj_id_pos = true

    log "Getting offsets for each object in Pdf file..."
    crt = ['0000000000 65535 f']
    while(obj_id_pos) do
      re = Regexp.new '^'+"#{i}"+' \d obj '
      obj_id_pos = pdf_content.index re
      break if obj_id_pos.nil?

      log "#{i} obj\t#{obj_id_pos}"
      crt << "#{obj_id_pos.to_s.rjust(10, '0')} 00000 n"
      i += 1
    end
    crt.unshift "0 #{i}"

    {entries: crt, count: i}
  end

  def update_cross_reference_table!(crt)
    start = pdf_content.index(/(?<= xref\n)/)
    stop = pdf_content.index(/.(?=\ntrailer)/)
    raise "Unable to determine boundaries for Cross Reference Table" if start.nil? or stop.nil?

    latter_half = pdf_content.slice!(stop+1, (pdf_content.length - (stop+1)))
    pdf_content.slice!(start, (stop+1)-start)
    @pdf_content = pdf_content + crt + latter_half
  end

  def update_crt_number_of_entries!(entries_count)
    log "updating number of entries in Cross Reference Table..."
    re_size = Regexp.new '\n/Root (\d+ \d+) R\n/Size \d+'
    log 're: \n/Root \1 R\n/Size '+"#{entries_count}"+''
    raise "Unable to determine number of entries in Cross Reference Table" if pdf_content.match(re_size).nil?
    pdf_content.gsub!(re_size, "\n\/Root "+'\1'+" R\n\/Size #{entries_count}")
  end

  def get_crt_offset(entries_count)
    log "updating offset to Cross Reference Table..."
    re_offset_crt = Regexp.new 'xref\n0 '+"#{entries_count}"+'\n'
    offset_crt = pdf_content.index re_offset_crt
    log "offset_crt: #{offset_crt}"
    raise "Unable to determine offset for Cross Reference Table" if offset_crt.nil?

    offset_crt
  end

  def update_crt_offset!(offset_crt)
    re_offset_crt_decl = /\nstartxref\n\d+\n/
    log 're: \nstartxref\n'+"#{offset_crt}"+'\n'
    raise "Unable to update offset for Cross Reference Table" if pdf_content.match(re_offset_crt_decl).nil?
    pdf_content.gsub!(re_offset_crt_decl, "\nstartxref\n#{offset_crt}\n")
  end

  def user_confirm(override=false, &blk)
    log "The Cross Reference Table has been refreshed"
    log "Option used to suppress user confirmation" if override

    ans = ((override) ? 'y' : input("Are you sure you want to update the Pdf file? (y/n)"))

    blk.call(ans)
  end

  def input(prompt="", newline=false)
    prompt += "\n" if newline
    Readline.readline(prompt, true).squeeze(" ").strip
  end

  def repair
    begin
      @pdf_content = get_pdf_content()
      mk_backup()

      crt = generate_cross_reference_table
      update_cross_reference_table!(crt[:entries].join("\n"))
      update_crt_number_of_entries!(crt[:count])
      update_crt_offset! get_crt_offset(crt[:count])

      user_confirm(@override) {|ans|
        if(ans.downcase == 'y')
          File.open(filename, "wb"){|f| f.write pdf_content}
          log "Pdf file has been successfully modified: #{filename}"
        else
          raise "Action aborted (per user request); Pdf file was not modified"
        end
      }

    rescue Exception => e
      raise "Unable to repair Pdf file: #{e.message}; #{e.backtrace.join("\n")}"
    end
  end
end

# filename = "/Users/davidvezzani/Downloads/wip01/crystal-commerce-invoice-sample-002.pdf"
filename = ARGV[0]
if(File.exists?(filename))
  PdfRebuildCrossReferenceTable.new(filename).repair()
else
  log "Cannot find file: #{filename}"
end
