import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)


const routes =[
  {
    path: '/'
  },
  {
    path: "/:id"
  }
]
const router = new Router({
  routes
})
export default router