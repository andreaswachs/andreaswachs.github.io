import { createApp } from 'vue'
import App from './App.vue'

import 'katex/dist/katex.min.css';
import Katex from 'katex'

// default highlight css file
import 'highlight.js/styles/atom-one-light.css'


// materialzie css
import 'materialize-css/dist/css/materialize.css'

// materialize js
import 'materialize-css/dist/js/materialize.min'

// material design icons
import 'material-design-icons'

import router from './router'

createApp(App)
    .use(router)
    .use(Katex)
    .mount('#app')