# For more information see: http://emberjs.com/guides/routing/

Revolution.Router.map ()->
  @resource 'posts', path: '/', ->
    @route 'new', path: '/posts/new'
    @resource 'posts.show', path: '/posts/:post_id', ->
      @route 'edit'
  @route 'login'
  @resource 'contact', ->
    @route 'thanks'
  @route 'about_us'
  @resource 'members', ->
    @resource 'members.show', path: ':user_id', ->
      @route 'edit'
      @route 'posts'
      @route 'projects'
  @resource 'projects', ->
    @route 'new'
    @resource 'projects.show', path: ':project_id', ->
      @route 'edit'

Revolution.Router.reopen
  location: "history"