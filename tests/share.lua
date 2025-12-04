package.path = "./?.lua;./?/init.lua;" .. package.path

local Observable = require("reactivex.observable")

require('reactivex.operators.share')

describe('share', function()
  it('is equivalent to publish():refCount()', function()
    local source = require("reactivex.subjects.subject").create()
    local shared = source:share()
    local a, b = {}, {}

    shared:subscribe(function(v) table.insert(a, v) end)
    shared:subscribe(function(v) table.insert(b, v) end)

    source:onNext(1)
    source:onCompleted()

    expect(a).to.equal({1})
    expect(b).to.equal({1})
  end)
end)
