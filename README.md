
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




## Some principles


### Dont try optimize too soon

```Premature Optimization Is the Root of All Evil```

Premature optimization is spending a lot of time on something that you may not actually need. 

One of the biggest challenges is making sure we are making good use of our time

My biggest concern right now isn’t performance or scale. I’m spending my time working on prototyping some of the features and designing UI mockups of other parts of the product. I have been focusing on getting user feedback to iterating on the final product features and functionality. I am trying to prevent wasting a lot of time on things that may never be needed.



### Consistency is key

Consistency is defined as: sameness, conformity, uniformity.

``` Consistently bad is better than inconsistently good. ```

Imagine a system initially developed with Technique A. A new software developer joins, and starts using technique B, which is objectively better than Technique A. Years later, that software developer is replaced by another developer, who uses Technique C, an arguably better technique than either Technique A or Technique B. Let this repeat.
What you end up with is a software system with X number of ways of doing the same thing. You use up precious brain-space to accommodate the X different methods of doing things, and you can never really be sure which way you’ll be encountering in your codebase.

Although beneficial when taken individually, the improvements as a group introduced inconsistency which made the system harder to reason about over time.

Code should look like it was written by a single individual.




## Some rules

- Eviter de mettre du business related dans le service/api, 
- ne pas faire une route dans l'api pour chaque function, 
- nommer les variables avec _ plutot que camelcase, 
- avoir un MDD le plus flat possible, 
- faire une route d'upload des images plutot que s'emmerder a merger ca avec un put etc... 
- dont create   wasRefused: false properties but instead status : String {REFUSED,ACCEPTED,PENDING}
