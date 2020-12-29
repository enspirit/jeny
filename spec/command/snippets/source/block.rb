module Foo

  METHOD_LIST = [
    :hello,
    #jeny(method) :${name},
  ]

  def hello
    "World"
  end

  #jeny(method) def ${name}
  #jeny(method)   # TODO: implement me
  #jeny(method) end

end
