module Restful
  include Rails.application.routes.url_helpers
  
  attr_reader :actions
  
  def self.mapping
    @_mapping ||= { }
  end
  
  def self.initialize_mapping
    Rails.application.routes.routes.each do |route|
      unless route.verb.empty?
        verb       = route.verb.downcase.to_sym
        controller = route.conditions[:controller]
        action     = route.conditions[:action]
        
        mapping[controller]         ||= { }
        mapping[controller][action]   = { method: verb }
      end
    end
  end
  
  def default_actions
    { show:    { method: :get    }, 
      update:  { method: :put    }, 
      create:  { method: :post   }, 
      destroy: { method: :delete } }
  end
  
  def default_actions_with_restrictions(*restrictions)
    default_actions.reject { |k, v| restrictions.include? k }
  end
  
  def default_allowed_actions(*whitelist)
    default_actions.select { |k, v| whitelist.include? k }
  end
  
  def setup_actions_from_controller(controller)
    if Restful.mapping.empty?
      Restful.initialize_mapping
    end
    allowed_actions Restful.mapping[controller.class.to_s.sub(/_controller$/,'')]
  end
  
  # accepts a hash of actions, keyed by action
  #
  #  e.g. { complete_challenge: { method: :put, as: :member } }
  # 
  # I would much rather imply these from the controller and routes
  def allowed_actions(allowed)
    self.actions ||= { }
    prefix         = self.class.to_s.demodulize.tableize.singularize

    allowed.each do |k,v|
      action_alias = v[:action_alias] || k
      url         = case k
                    when :show, :update, :delete
                      send "#{prefix}_url", self
                    when :new
                      send "new_#{prefix}_url"
                    when :create
                      send "#{prefix.pluralize}_url"
                    else
                      if v[:as] == :member
                        send "#{k}_#{prefix}_url", self
                      elsif v[:as] == :collection
                        send "#{k}_#{prefix.pluralize}_url"
                      else
                        raise Exception.new("Must specify member or collection for custom action")
                      end
                    end
      
      actions[action_alias] = { url: url, method: v[:method] }
    end
  end
  
  def as_json(options = { })
    super.merge actions: actions
  end
  
  def default_url_options
    @_default_url_options ||= Rails.application.routes.default_url_options.dup
  end
  
  protected
  attr_writer :actions
  
  
end
