
## Our stack

- AWS ( Or azure when needed )


- ReactJs
- Styled components
- Reactstrap
- Nodejs / Express 
- MongoDb / Mongoose 

- ElasticSearch ( only when high volume / complexe queries are required , connected with mongoosastic) 
- React Native

- Sentry
- RobotUpTime

- AmplitudeJS
- Trello 


## Working guidelines

1) Each of your code should be PRs to another dev
2) We use git flow  ( https://datasift.github.io/gitflow/GitFlowFeatureBranches.png ) when we are in production. When we are in alpha, we just use a one branch



## Coding good practices ( WIP)


- Make your code readable 
- Comment when you can't make your code readable
- Deliver core features first and fast ( high added value )
- KISS (Keep it simple) @todo 
- Services and global components should be business agnostic
- Prefer copy paste the same code instead of DRY ( dont repeat yourself) for readibility
- Use linter @todo seb
- Single responsibility principle @todo 
- Make your data model as simple as possible  @todo 
- Use CRUD in api efficiently


- ne pas faire une route dans l'api pour chaque function, 
- dont create a function used once which is only one line



- faire une route d'upload des images plutot que s'emmerder a merger ca avec un put etc... 





- dont create   wasRefused: false properties but instead status : String {REFUSED,ACCEPTED,PENDING}





## Some principles

### Deliver fast high added valuable for the client

What client really need . Its not the login, or onboarding or a filters. Its the core features of the products
Even if it the project manager goal to take care of priorities with the client, the developer should always keep in mind core features

### Services and components should be business agnostic

Examples :

The api in services/api.js could/should be copy paster from a project to another without much modications

A components table.js in the global component folders (Smart Table) shouldnt care if it deals with the business data. It should just care only into rendering stuff



### Make your code readable

The code should be easy to understand ( even more than optimisation ) . For example, we want to check on the logic side if we have duplicated emails : 

```
if (body.hasOwnProperty("email") && (user.email !== email)) {
    const userWithEmail = await UserObject.findOne({ email });
    if (userWithEmail) return res.status(400).send({ ok: false, code: EMAIL_ALREADY_EXISTS });
    user.email = email;
}
```

The code is hard to read and understand . 

The code bellow is easier

```
if (body.hasOwnProperty("email")) {
   const userWithEmail = await UserObject.findOne({ email });
   if (userWithEmail && userWithEmail._id !== user._id) return res.status(400).send({ ok: false, code: EMAIL_ALREADY_EXISTS });
   user.email = email;
  }
}
```

### Comment when you can't make your code readable

Sometimes, you can't make the code easy to read. Then , please add a comment ! 

Example : Usage of the Never used Sparse property


```
 // Sparse means can be nullable. The purpose is to have unique check only if
  // value is present in the field
  email: { type: String, unique: true, sparse: true },
  ```
  
  
### Prefer copy paste same code instead of DRY ( dront repeat yourself) for readibility

Find useAPI @arnaud


### Use CRUD in api efficiently

For example, 

two routes : 

```
put(`/user/setUserName`, {name})
put(`/user/setUserPhone`, {phone})
```

Can be simplify in
```
put(`/user`, {name, phone }) 
```
but use 
```
const obj = {}
body.hasOwnProperty("name") && obj.name = body.name
body.hasOwnProperty("phone") && obj.phone = body.phone
```


### Make your data model as simple as possible 

For example, a dev dont need to create a table for a feature like in password reset ( with token, expiration etc .. ) I can't simply create 2 properties in user : 
password_reset_expire
password_reset_token


@arnaud : trouver l'article sur quand faire une nouvelle collection 


### Dont try optimize too soon

```Premature Optimization Is the Root of All Evil```

Premature optimization is spending a lot of time on something that you may not actually need. 

One of the biggest challenges is making sure we are making good use of our time


The more confidence you have that you are building the right things, the more time you should put into proper software architecture, performance, scalability, etc. Striking this balance is always the challenge. Like most things in life, the answer is almost always “it depends”.

The performance and scalability of your application are important. You just need to make sure you are building the right feature set first. Avoid premature optimization by getting user feedback early and often from your users.



### Consistency is key

Consistency is defined as: sameness, conformity, uniformity.

``` Consistently bad is better than inconsistently good. ```

Imagine a system initially developed with Technique A. A new software developer joins, and starts using technique B, which is objectively better than Technique A. Years later, that software developer is replaced by another developer, who uses Technique C, an arguably better technique than either Technique A or Technique B. Let this repeat.
What you end up with is a software system with X number of ways of doing the same thing. You use up precious brain-space to accommodate the X different methods of doing things, and you can never really be sure which way you’ll be encountering in your codebase.

Although beneficial when taken individually, the improvements as a group introduced inconsistency which made the system harder to reason about over time.

Code should look like it was written by a single individual.
