var FailingSpec = new Object();
FailingSpec.name = "Failing Spec";
Spec.register(FailingSpec);

FailingSpec.describe("A failing spec", {
	'fails': function() {
		value_of(true).should_be(false);
	}
})
