module ETFlex::Spec
  module WaitForXHR

    # A helper method which tells Capabara to wait until jQuery has finished
    # processing any asynchronous HTTP requests.
    def wait_for_xhr
      wait_until { page.evaluate_script('jQuery.active') == 0 }
    end

  end # WaitForXHR
end # ETFlex::Spec
