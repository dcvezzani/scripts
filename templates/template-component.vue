<template>
  <div class="$label">
		$name
  </div>
</template>

<script>
export default {
  name: '$name',
  props: ['name'],
  // components: { Junk },
  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
    }
  },
  computed: {
    stuff: function() {
			return 'stuff';
		},
  },
  methods: {
    junk: function() {
		},
  },
  sockets:{
    "$name:blah": function(data){
		  console.log('$name:blah', data);
			this.$socket.emit('$name:blah', {msg: 'bleh'});
    },
  },
  mounted () {
		window.Event.$on('$name:activate', (data) => {
		  console.log('$name:blah', data);
			window.Event.$emit('$name:activated', {msg: 'done'});
		});
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>

