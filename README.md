# Cassis

*Cassis* is a simple architectural framework that compartmentalizes layers concerned with use cases from layers concerned with business entities, persistence, and the boundary between the functional core and the outer imperative shell.

The central abstraction upon which *Cassis* is designed is the concept of a *Use Case*. *Use Case* is the fundamental unit of delivery, the most atomic unit of work that delivers desired business outcome.

Each and every *Use Case* relies on the participating *business entities* (i.e. *collaborators*) to deliver the desired outcome upon receiving a *trigger event*. This trigger event causes the *Use Case* to run, and thus process the received information and produce the desired business outcome. During the processing of the received information, a *Use Case* does not depend on any delivery mechanism. This means that a *Use Case* in *Cassis* can process information and deliver business outcome equally well regardless of whether this information gets delivered on the web, as a background task, or using a RESTful API etc.

The most important feature of the *Cassis* framework is that it is 100% independent of any external delivery or persistence mechanisms. The intention is to keep *Cassis* pristine in the sense that it remains blissfully ignorant of the outside world. All *Cassis* is aware of, with regards to the external world, is that there exists such thing as a delivery mechanism, which is represented to the *Cassis* as a construct called *Boundary*. This construct is responsible for relaying end-user gestures to the *Cassis* framework, and for responding with any values that may result from a particular *Use Case* that gets triggered by the *Boundary*. In addition, *Cassis* is also aware of the construct called *Repository*, which is responsible for ensuring persistence of enterprise business entities, such as *Customers*, *Products*, *Orders*, etc.


## Cassis Architecture

_Cassis_ is structured as a full-blown functional core surrounded by the thin imperative layer. On its own, the core functional framework cannot interact with the outside world, and is therefore incapable of fielding end-user requests. It is also incapable of informing end-users about the results produced within the functional core. In addition, the functional core is incapable of persisting any information that has been processed within it.

All those external capabilities needed for the functional core to interact with end-users are delegated to some form of implementation of the outer imperative layer. Because of this agnostic architecture, _Cassis_ is a representative of the _pluggable architecture_.

What are the advantages of such _pluggable architecture_? By postponing the decisions related to how to interact with end-users as well as how to persist the values that got produced as the result of the functional processing within the functional core, _Cassis_ remains open to adding commoditized technologies that specialize in dealing with end-user interactions etc. That way, _Cassis_ is well positioned to leverage many future improvements in price/performance regarding processing end-user interactions and persisting facts.


## Cassis Structure

The _use case centric_ nature of the _Cassis_ framework follows the rationale that any software project always implements, first and foremost, a collection of use cases. Once all the relevant use cases have been defined for a particular software product, that collection of use cases can be viewed as the _blueprint_ of the proposed product. Typically (and most desirably), such software _blueprint_ will be formulated using the 'ubiquitous language' (ubiquitous in the sense that it can be shared both by formally trained technical team members and the team members responsible for running the business). Most likely, the ubiquitous language will consist of _user stories_. Each _user story_ formally consists of three lines; the first line establishes an _actor_ ('As a customer', for example); the second line establishes a desired _goal_ (i.e. 'I want to log in'); finally, the third line clarifies the benefit of the user story. If the proposed user story does not further the business case in any defendable fashion, then the user story will most likely get rejected. This approach to building a blueprint of the business solution guarantees that such a solution will remain _lean_, i.e. only useful features will end up being implemented.

Each accepted user story will further elaborate on one or more scenarios. It is those scenarios that are a starting point for articulating the use cases. Once use cases get articulated, they must be implemented using some programming language. In our case, we have chosen Ruby as the implementation language.

Typically, on any software project, the implementation will not clearly map back onto the firmed up use cases. Often times, in order to verify if a given use case has been implemented properly, one must follow the execution logic as implemented in the programming language, and this following of the execution logic will almost always lead one to hop in and out of many different files. It goes without saying that this 'file hopping' is not very conducive to efficient analysis of the implemented code, leaving open the possibility of overlooking bugs and defects.

In order to streamline and tighten our ability to reason about the implemented code, we are proposing a _use case centric_ software framework, such as _Cassis_. This framework offers to normalize the focus on the business solution blueprint by enforcing centralization of use cases. Each project built using this framework will have all use cases (comprising the blueprint) consolidated in a single location. All use cases implemented in the _Cassis_ framework are localised inside the _use cases_ folder that exists inside the _lib_ folder. In our illustration here, we have defined only one hypothetical use case called _create product_. This use case has only two capabilities: it can get initialized, and once initialized, it can run.

As we've already mentioned, because a use case within the _Cassis_ framework is hosted inside the pure functional core, it is not capable of managing destructive events, such as end-user gestures etc. Because of that, _Cassis_ defines the *Boundary* construct, which acts as a representative of the so-called 'scar tissue' that forms between the outer imperative shell and the inner functional core. This _boundary_ is implemented in the _Cassis_ framework in the _lib_ folder. *Boundary* is therefore an entity that is fully aware of the inner use cases, while no use case inside the functional core is aware of the outside boundary (unless that boundary gets passed in as a dependency injection during the use case initialization). All that use cases worry about is to ensure proper processing of a given use case, as defined in the user stories and scenarios defined using the ubiquitous language.

*Boundary* is therefore responsible for collecting the end-user gestures, and for initiating the running of a particular use case. Upon receiving the notification to run, the called use case will collect the values that have been passed in by the *Boundary* together with the event notification, and then the particular _use case_ will process the scenario, as it is defined inside the user story.

Each _use case_ must rely on other actors (or entities) that get defined inside this simple framework. First and foremost, business entities are defined inside the _entities_ folder. In there, we declare the structure and the capabilities of our business entities. In our simple illustration, we have merely declared an entity called _product_. To keep things simple, we have endowed this entity with two simple capabilities -- it can initialize itself, and it can persist itself (i.e. _save_). We didn't go into any details illustrating how would a business entitiy initialize and save itself, and those are specific to the particular business domain.

Another important actor in this simplistic framework is a _Repository_. This repository is responsible for creating instances of business entities, persisting business entities to an auxiliary storage, and also for validating various aspects of a business entity.

Finally, after processing an event that arrives from the outer imperative shell, a message must propagate back to the event initiator, informing of the success or failure of the event processing. That responsibility once again falls squarely on the shoulders of a *Boundary*, which is capable of propagating a _success_ or a _failure_ message to the outside caller.


## Business Validations in the Cassis Framework

Because *Cassis* is independent from any implementation concerns, it is not beholden by the relational database specific methods of validation. This freedom from dependency on the underlying persistence mechanisms allows *Cassis* to implement any conceivable kinds of validations that make sense in the business context, while disregarding the technology context.

In contrast, validations that are driven by the underlying limitations of the relational database, such as in the case of the *Rails ActiveRecord*, are sometimes ham fisted because such validations cannot distinguish between various business contexts. As such, the ActiveRecord-based validations are sometimes considered insufficient.

For this particular implementation, we have chosen the *applicative validation* methodology, which uses disjoint union type for the return value. What that means is that the information regarding whether the complex validation processing has succeeded or failed is contained within this new data type, also known as "either". A final result of the involved and potentially intricate validation process is either a correct value or it contains the description (or, a series of applicative descriptions) explaining what went wrong along the way. Whichever the case may be, applicative validation always returns a simple answer -- either the validation process succeeds and the correct value gets returned, or the validation process fails and the descriptive explanation gets returned. This simple answer is independent of the complexity of the validation process, which may involve numerous intricate business rules and elaborate steps.

Applicative validation's power lies in the fact that it is not procedural by nature, which makes it much simpler to implement, maintain, reason about, test, and debug. Such declarative coding style is always preferred over the imperative coding style.

## Cassis Architecture Diagram

<img src="https://raw.githubusercontent.com/alexbunardzic/cassis/master/Cassis%20architecture.jpg"></img>

Diagram 1. An extremely simplified diagram of the proposed _use case-centric_ architecture.

In the above diagram we have depicted a situation where an end-user is the sole originator of the events that transpire on the system and are of interest to the business. Upon the arrival of such an event, originated by the end-user, the unspecified delivery mechanism (possibly a web form) propagates the event, together with the accompanying values, to the *Boundary* component. When the *Boundary* receives the message, it gets initialized by setting up the appropriate context and by executing the appropriate use case. The use case runs (in this illustration the use case is _create product_), and in the process involves business entities, such as for example *Product*. Business entities get instantiated and persisted by using the services of the *Repository* layer, which sits outside of the pure functional core. Finally, the result of the running use case gets propagated back to the *Boundary*, which then communicates the messages to the end-user.

## How to Execute the Cassis Framework

For simple demonstration purposes we can exercise this bare bones framework by running it from the command line and passing in arbitrary list of arguments:

$ ruby -r "./boundary.rb" -e "Boundary.rb ['string', 2, 42]"

## Cassis Code Walk-through

As already discussed, the point of contact between the outside world (i.e. the world of commoditized outer imperative shell) and the inner core competency layer (i.e. the layer that implements business entities, entity gateway/repository, and specific use cases) is the so-called 'scar tissue' represented as a compartmentalized component called *Boundary*. This component gets initialized by the outer imperative shell that passes in an arbitrary list of arguments. Upon receiving the message to initialize itself, *Boundary* checks whether it has access to the instance of a *Repository*. If not, *Boundary* will instantiate *Repository* and will then run the use case:

```
  def initialize(*args)
  	@repository ||= Repository.new
  	create_product(*args)
  end
```

When the use case runs, it instantiates the class representing that use case, performs dependency injection (i.e. that instance of *Boundary* injects itself into the use case), and the runs the use case while passing in the list of arguments:

```
  def create_product(*args)
  	CreateProduct.new(self).run(*args)
  end
```

*CreateProduct* class implements the 'create product' use case, as defined in the corresponding user story and its accompanying scenarios. Upon getting initialized, the instance of this use case will first equate the injected instance of *Boundary* with the value @boundary, and will then obtain an instance of *Repository* from the instantiated *Boundary*; this instance will be stored in the value @repository:

```  
  def initialize(boundary)
  	@boundary = boundary
  	@repository = boundary.repository
  end
```


### When the Use Case Runs

Here finally is what might happen when the proverbial rubber meets the road:

```
  def run(*args)
  	product = repository.new_product(*args)
  	result = repository.validate_product_nil(product, "Product is nil").lift_to_a +
  	result = repository.validate_name_not_blank(*args, "Name is blank").lift_to_a

  	unless Validator.valid?(result){|args| product}
  	  result.left.bind do |e|
  	  	boundary.failure(e.join(', '))
  	  end
  	else
  	  if repository.save_product(product)
  	    boundary.success(product)
  	  else
  	    boundary.failure("Product not saved")
  	  end
  	end
  end
```

We have kept the complexity of the use case extremely simple, for the purposes of illustration. A real life example would of course be mmuch more involved. Suffice it to say that it is in this method that we must implement all the processing logic that is governing the behaviour of the use csae. In this example, we see that the use csase simply obtains an instance of the business entity *Product* from the instance of *Repository* and then immediately validates the obtained product. The validations are implemented at the repository level, and the result of the validation is stored in the value aptly named _result_.

Depending on the result of the validation, the use case will either bail and short circuit the processing of the main success scenarion, or will continue processing the scenario. If the scenario fails, the use case will send a failure message to the instance of *Boundary*; this instance will then take care of propagating the failure message all the way up to the outer imperative shell. If the validation is successful, the use case will continue with processing the scenario and will finally attempt to persist the business entity. Here again, the action may succeed or fail -- the use case will again communicate the situation to the instance of *Boundary* and the message will get sent to the outside world.



