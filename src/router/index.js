import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import About from '../views/About.vue'
import Post from '../views/Post.vue'
import Posts from '../views/Posts.vue'
import Projects from '../views/Projects.vue'
import Project from '../views/Project.vue'

const routes = [{
        path: '/',
        name: 'Home',
        component: Home
    },
    {
        path: '/about',
        name: 'About',
        component: About
    },
    {
        path: '/post/:id',
        name: 'Post',
        component: Post
    },
    {
        path: '/posts',
        name: 'Posts',
        component: Posts,
    },
    {
        path: '/projects',
        name: 'Projects',
        component: Projects
    },
    {
        path: '/project/:name',
        name: 'Project',
        component: Project
    }

]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
})

export default router