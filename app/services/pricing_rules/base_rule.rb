module PricingRules
  class BaseRule
    def apply(cart_items)
      raise NotImplementedError, "Subclasses must implement the apply method"
    end
  end
end
