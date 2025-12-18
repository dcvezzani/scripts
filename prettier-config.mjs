import xmlPlugin from '/Users/dcvezzani/.nvm/versions/node/v20.11.0/lib/node_modules/@prettier/plugin-xml/src/plugin.js';

export default {
  plugins: [xmlPlugin],
  semi: true,
  trailingComma: 'none',
  singleQuote: true,
  overrides: [
    {
      files: '*.xml',
      options: {
        xmlWhitespaceSensitivity: 'ignore',
      },
    },
    {
      files: '*.html',
      options: {
				bracketSameLine: true,
				htmlWhitespaceSensitivity: 'ignore',
      },
    },
  ],
};

