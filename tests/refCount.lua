package.path = "./?.lua;./?/init.lua;" .. package.path

local Observable = require("reactivex.observable")
local Subject = require("reactivex.subjects.subject")
local Subscription = require("reactivex.subscription")

require('reactivex.operators.publish')
require('reactivex.operators.refCount')

describe('refCount', function()
  it('auto-connects on first subscriber and disconnects on last', function()
    local source = Subject.create()
    local unsubscribes = 0

    local observable = Observable.create(function(observer)
      local innerSub = source:subscribe(observer)
      return function()
        unsubscribes = unsubscribes + 1
        innerSub:unsubscribe()
      end
    end)

    local shared = observable:publish():refCount()

    local first, second = {}, {}
    local subA = shared:subscribe(function(value) table.insert(first, value) end)
    expect(unsubscribes).to.equal(0)

    local subB = shared:subscribe(function(value) table.insert(second, value) end)

    source:onNext(1)
    source:onNext(2)
    expect(first).to.equal({1, 2})
    expect(second).to.equal({1, 2})
    expect(unsubscribes).to.equal(0)

    subA:unsubscribe()
    expect(unsubscribes).to.equal(0)

    subB:unsubscribe()
    expect(unsubscribes).to.equal(1)
  end)
end)
