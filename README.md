# Concierge

*Concierge* is a financial platform that specializes in providing various types of loans to the qualifying customers.

The central abstraction upon which concierge is designed is the concept of a *Use Case*. *Use Case* is the fundamental unit of delivery, the most atomic unit of work that delivers desired business outcome.

Each and every *Use Case* relies on the participating *business entities* (i.e. *collaborators*) to deliver the desired outcome upon receiving a *trigger event*. This trigger event causes the *Use Case* to run, and thus process the received information and produce the desired business outcome. During the processing of the received information, a *Use Case* does not depend on any delivery mechanism. This means that a *Use Case* in *concierge* can process information and deliver business outcome equally well regardless of whether this information gets delivered on the web, as a background task, or using a RESTful API etc.

The most important feature of the *concierge* platform is that it is 100% independent of any external delivery or persistence mechanisms. The intention is to keep *concierge* pristine in the sense that it remains blissfully ignorant of the outside world. All *concierge* is aware of, with regards to the external world, is that there exists such thing as a delivery mechanism, which is represented to the *concierge* as a construct called *Boundary*. This construct is responsible for relaying end-user gestures to the *concierge*, and for responding with any values that may result from a particular *Use Case* that gets triggered by the *Boundary*. In addition, *concierge* is also aware of the construct called *Repository*, which is responsible for ensuring persistence of enterprise business entities, such as *Customers*, *Products*, *Loans*, and *Agreements*.


## Concierge is a Bookkeeping System

Financial Loan Platform is an event-driven system. As various events arise during the usual workaday, some of those events are important enough to be recorded in the system. Once recorded, such events become *facts*.

**FACTS NEVER CHANGE**. Because of this arrangement, *concierge* is not a *CRUD* system (in other words, it does not obey the usual Create-Read-Update-Delete model). The only destructive operation allowed in concierge is *create* (meaning, the only allowed non-idempotent operation is inserting new records into the system). Updates and deletes are outlawed from this bookkeeping system. This arrangement guarantees pristine quality of the facts stored within the system.

Because of this arrangement, *concierge* cannot benefit from utilizing the capabilities of typical software frameworks, such as *Ruby on Rails*. *Rails* is a state of the art CRUD machine, and once we outlaw CRUD, there remain very few useful services and capabilities that Rails can offer to such bookkeeping system.


## Concierge Architecture

_Concierge_ is structured as a full-blown functional core surrounded by the thin imperative layer. On its own, the core functional shell cannot interact with the outside world, and is therefore incapable of fielding end-user requests. It is also incapable of informing end-users about the results produced within the functional core. In addition, the functional core is incapable of persisting any information that has been processed within it.

All those external capabilities needed for the functional core to interact with end-users are delegated to some form of implementation of the outer imperative layer. Because of this agnostic architecture, _concierge_ is a representative of the _pluggable architecture_.

What are the advantages of such _pluggable architecture_? By postponing the decisions related to how to interact with end-users as well as how to persist the values that got produced as the result of the functional processing within the functional core, _concierge_ remains open to adding commoditized technologies that specialize in dealing with end-user interactions etc. That way, _concierge_ is well positioned to leverage many future improvements in price/performance regarding processing end-user interactions and persisting facts.


## Business Validations in Concierge

Because *concierge* is independent from any implementation concerns, it is not beholden by the relational database specific methods of validation. This freedom from dependency on the underlying persistence mechanisms allows *concierge* to implement any conceivable kinds of validations that make sense in the business context, while disregarding the technology context.

In contrast, validations that are driven by the underlying limitations of the relational database, such as in the case of the *Rails ActiveRecord*, are hamfisted because such validations cannot distinguish between various business contexts. As such, the ActiveRecord-based validations are considered harmful.

For this particular implementation, we have chosen the *applicative validation* methodology, which uses disjoint union type for the return value. What that means is that the information regarding whether the complex validation processing has succeeded or failed is contained within this new data type, also known as "either". A final result of the involved and potentially intricate validation process is either a correct value or it contains the description (or, a series of applicative descriptions) explaining what went wrong along the way. Whichever the case may be, applicative validation always returns a simple answer -- either the validation process succeeds and the correct value gets returned, or the validation process fails and the descriptive explanation gets returned. This simple answer is independent of the complexity of the validation process, which may involve numerous intricate business rules and elaborate steps.

Applicative validation's power lies in the fact that it is not procedural by nature, which makes it much simpler to implement, maintain, reason about, test, and debug. Such declarative coding style is always preferred over the imperative coding style.


## Abandon Database Generated Surrogate IDs

A lot (if not most) of the Rails magic resides in its reliance on using incrementally generated numeric IDs when linking related entities. Whenever a new instance of a business entity gets inserted into the relational database, a unique numeric surrogate ID gets incrementally generated. This unique numeric ID is then used for all subsequent idenification of that instance. In a typical CRUD environment, such unique ID will get used for retrieving the instance recorded in the database, and then possibly updating that record, or perhaps even deleting it.

Because *concierge* is not architected on the CRUD model (i.e. all updates and deletions are outlawed), this arrangement whereby a unique ID is automatically generated by the relational database is meaningless. Instead, each instance of a business entity in *concierge* must be identifiable via a unique surrogate primary key which gets produced by the business logic inside the *concierge*.




