local Observable = require 'reactivex.observable'
local Subject = require 'reactivex.subjects.subject'

-- Turns a cold Observable into a ConnectableObservable that shares a single
-- subscription through an internal Subject. Call :connect() to subscribe the
-- source; downstream subscribers attach to the subject.
function Observable:publish()
  local source = self
  local subject = Subject.create()
  local connection

  local connectable = Observable.create(function(observer)
    return subject:subscribe(observer)
  end)

  function connectable:connect()
    if not connection then
      connection = source:subscribe(
        function(...) subject:onNext(...) end,
        function(err)
          subject:onError(err)
          connection = nil
        end,
        function()
          subject:onCompleted()
          connection = nil
        end
      )
    end

    return connection
  end

  function connectable:unsubscribe()
    if connection then
      connection:unsubscribe()
      connection = nil
    end
  end

  return connectable
end
