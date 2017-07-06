import App

/// We have isolated all of our App's logic into
/// the App module because it makes our app
/// more testable.
///
/// In general, the executable portion of our App
/// shouldn't include much more code than is presented
/// here.
///
/// We simply initialize our Droplet, optionally
/// passing in values if necessary
/// Then, we pass it to our App's setup function
/// this should setup all the routes and special
/// features of our app
///
/// .run() runs the Droplet's commands, 
/// if no command is given, it will default to "serve"
let config = try Config()
try config.setup()

let drop = try Droplet(config)
try drop.setup()

drop.get("user") { req in
    return try JSON(node: [
        "name": "sunny",
        "job": "iOS programer",
        "gender": 1
        ])
}

drop.post("users", User.parameter) { req in
    let user = try req.parameters.next(User.self)
    return try JSON(node: [
        "key": req.parameters
        ])
}

drop.get("404") { req in
    
    throw Abort(.notFound)
}

drop.get("error") { req in
    throw Abort(.badRequest, reason: "Sorry 😨")
}



try drop.run()
