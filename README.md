# Restful role for Rails models

This is has been pulled from another project where it is fully tested and it's only here for convenience since I'm using it elsewhere. 

RESTful APIs should be discoverable and this mixin/role is a way to add mappings of restful actions to objects that are being rendered `as_json`. 

```
class BlahController
 before_filter :add_restful_role_to_blah
 
 respond_to :json
 
 def show
   respond_with resource
 end
 
 def update
   resource.update_attributes params[:blah]
   respond_with resource
 end
 
 protected
 def add_restful_role_to_blah
   resource.extend Restful
   resource.setup_actions_from_controller self
 end
end
```

In the above example, the resource returned would look something like this

```
{ 
  "id": 1,
  "attr": "fnord",
  "actions": {
    "show": { "url": "http://example.com/blah/1", "method": "get" }
    "update": { "url": "http://example.com/blah/1", "method": "put" }
  }
}
```

Available actions are inferred from the Rails route set.