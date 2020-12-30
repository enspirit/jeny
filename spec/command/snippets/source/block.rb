module Foo

  METHOD_LIST = [
    :hello,
    #jeny(method) :${op_name},
  ]

  def hello
    "World"
  end

  #jeny(method) def ${op_name}
  #jeny(method)   # TODO: implement me
  #jeny(method) end

end
