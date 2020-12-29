module Jeny
  class Dialect < WLang::Dialect

    def varvalue(buf, fn)
      var_name  = render(fn)
      var_value = evaluate(var_name)
      buf << var_value.to_s
    end
    tag '$', :varvalue

  end
end
