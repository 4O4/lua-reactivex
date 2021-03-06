local Observable = require("reactivex.observable")
local Observer = require("reactivex.observer")
local Subscription = require("reactivex.subscription")

require('reactivex.operators.defaultIfEmpty')

describe('defaultIfEmpty', function()
  it('errors if the source errors', function()
    expect(Observable.throw():defaultIfEmpty(1)).to.produce.error()
  end)

  it('produces the values from the source unchanged if at least one value is produced', function()
    expect(Observable.fromRange(3):defaultIfEmpty(7)).to.produce(1, 2, 3)
  end)

  it('produces the values specified if the source produces no values', function()
    expect(Observable.empty():defaultIfEmpty(7, 8)).to.produce({{7, 8}})
  end)

  it('does not freak out if no values are specified', function()
    expect(Observable.empty():defaultIfEmpty()).to.produce({{}})
  end)
end)
