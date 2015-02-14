define ['module'], (module) ->
  router = module.config()

  signIn: router.SessionController.create()
  signOut: router.SessionController.delete()
  signUp: router.AccountController.create()
