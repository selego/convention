
## Our stack

### Cloud

- AWS 
- Azure ( when needed ) 

### Tech 
- ReactJs
- Styled components
- Reactstrap
- Nodejs / Express 
- MongoDb / Mongoose 
- ElasticSearch ( only when high volume / complexe queries are required , connected with mongoosastic) 
- React Native

### Monitoring
- Sentry
- RobotUpTime
- AmplitudeJS
- Mixpanel ( For mobile apps ) 

### Project management 
- Trello 


## How works together

1. Each of your code should be PRs to another dev
2. We use git flow  ( https://datasift.github.io/gitflow/GitFlowFeatureBranches.png ) when we are in production. When we are in alpha, we just use a one branch
3. Continous deployment is setup on every project. 


## Coding good practices ( WIP)

1. Make your code readable 
2. Comment when you can't make your code readable
3. Deliver core features first and fast ( high added value )
4. KISS (Keep it simple) @todo 
5. Services and global components should be business agnostic
6. Prefer copy paste the same code instead of DRY ( dont repeat yourself) for readibility
7. Single responsibility principle @todo 
8. Make your data model as simple as possible  @todo 
9. Use CRUD in api efficiently
10. Anticipate less is better than anticipate too much
11. Check the boilerplate project  (https://github.com/selego/boilerplate)
12. Think about maintenance @todo seb
13. Dont try optimizing too soon
14. Consistency is key


### Make your code readable

The code should be easy to understand ( readibility >  optimisation ) . For example, we want to check on the logic side if we have duplicated emails : 

```
if (body.hasOwnProperty("firstName")) user.firstName = firstName;
if (body.hasOwnProperty("email") && (user.email !== email)) {
    const userWithEmail = await UserObject.findOne({ email });
    if (userWithEmail) return res.status(400).send({ ok: false, code: EMAIL_ALREADY_EXISTS });
    user.email = email;
}
```

The code is not easy to read and understand. Why is there an email check there and not somewhere else ? 

The code bellow is easier to understand : 

```
if (body.hasOwnProperty("firstName")) user.firstName = firstName;
if (body.hasOwnProperty("email")) {
   const userWithEmail = await UserObject.findOne({ email });
   if (userWithEmail && userWithEmail._id !== user._id) return res.status(400).send({ ok: false, code: EMAIL_ALREADY_EXISTS });
   user.email = email;
  }
}
```



### Comment when you can't make your code readable

Sometimes, you can't make the code easy to read. Then ,please add a comment ! 

Example : Usage of the Never used Sparse property


```
 // Sparse means can be nullable. The purpose is to have unique check only if
 // value is present in the field
email: { type: String, unique: true, sparse: true },

```
  
### Deliver fast high added valuable for the client

What client really need. Its not the login, or the onboarding or a filter. Its the core features of the products.
Even if its the project manager goal to take care of priorities with the client, the developer should always keep in mind core features


### KISS

@todo SEB


### Services and components should be business/logic agnostic

It's important to keep logic / business related stuff outside services or global components. 

- Example 1 :

The api in services/api.js could/should be copy paster from a project to another without much modications. 

- Example 2 : 

A components in the global app/src/component folder shouldnt care if it deals with the business/logic data. It should just care only into rendering stuff.


### Prefer copy paste same code instead of DRY ( dont repeat yourself) for readibility

This hooks was created in order to control every request to API : 

```
/**
 * Helper hook to fetch data on component mount
 *
 * @param {Function} toCall -> API function to call, when component gets mounted
 * @param args -> args to pass to the function
 *
 * @return {[boolean | null, Object | null, Object | null]} -> return status as first element(null while pending) data as second argument and error object as third
 */
export default (toCall, ...args) => {
  const { isInternetReachable } = useContext(NetworkContext);
  const [status, setStatus] = useState(null);
  const [err, setError] = useState(null);
  const [data, setData] = useState(null);

  const retry = async () => {
    try {
      if (isInternetReachable === false) throw new NoInternetConnectionError();

      const { ok, error, code, ...data } = await toCall(...args);
      setStatus(ok);

      if (ok) setData(data);
      else setError(error);
    } catch (e) {
      console.log('Error in useApi');
      console.log(e);
      setError(e);
    }
  };

  useEffect(() => {
    retry();
  }, []);

  return [status, data, err, retry];
};
```


It's hard to read and its aimed to create optimisations against readibility. Its more readeble to have several the same code on each routes handling errors


### Anticipate less is better than anticipate too much

Its better to spend less time , have less code and deliver faster than spend time optimising for futurs problems and features. We loose agility and readibility when we anticipate futur to much. 
Also, nobody knows the futur of any product. We could pivote the product or even stop it.

The goal is to deliver key features for the client to validate the product.



 ### Single responsibility principle
 
@todo SEB


### Make your data model as simple as possible  ( as flat as possible )

For example, a dev dont need to create a table/collection for a feature like in password reset ( with token, expiration etc .. ). We can simply create 2 properties in user : 
password_reset_expire
password_reset_token

@arnaud : trouver l'article sur quand faire une nouvelle collection 


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

but use this to control the scope of the properties updated

```
const obj = {}
body.hasOwnProperty("name") && obj.name = body.name
body.hasOwnProperty("phone") && obj.phone = body.phone
```


### Check the boilerplate project

Please check the boilerplate project for example and get started stuff

https://github.com/selego/boilerplate


### Think about maintenance

@todo SEB

### Dont try optimizing too soon

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




------------------




TODO LATER : 

- faire une route d'upload des images plutot que s'emmerder a merger ca avec un put etc... 
