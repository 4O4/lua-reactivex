package.path = "./?.lua;./?/init.lua;" .. package.path

local Observable = require("reactivex.observable")
local Subject = require("reactivex.subjects.subject")

require('reactivex.operators.publish')

describe('publish', function()
  it('multicasts a single source subscription to many observers', function()
    local subscribeCount = 0
    local source = Observable.create(function(observer)
      subscribeCount = subscribeCount + 1
      observer:onNext('a')
      observer:onCompleted()
    end)

    local connectable = source:publish()

    local first, second = {}, {}
    connectable:subscribe(function(value) table.insert(first, value) end)
    connectable:subscribe(function(value) table.insert(second, value) end)

    local connection = connectable:connect()

    expect(subscribeCount).to.equal(1)
    expect(first).to.equal({ 'a' })
    expect(second).to.equal({ 'a' })

    connection:unsubscribe()
  end)
end)
