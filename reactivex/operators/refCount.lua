local Observable = require 'reactivex.observable'
local util = require 'reactivex.util'

-- Auto-connects a connectable observable on first subscriber and disconnects
-- when the last subscriber unsubscribes.
function Observable:refCount()
  local connectable = self
  local refCounter = 0
  local connection

  local function tryConnect()
    if not connection then
      connection = connectable:connect()
    end
  end

  local function tryDisconnect()
    if connection and refCounter == 0 then
      connection:unsubscribe()
      connection = nil
    end
  end

  return Observable.create(function(observer)
    refCounter = refCounter + 1
    local subscription = connectable:subscribe(observer)
    tryConnect()

    return function()
      subscription:unsubscribe()
      refCounter = refCounter - 1
      tryDisconnect()
    end
  end)
end
