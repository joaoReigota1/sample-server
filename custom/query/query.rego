package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_elb[name]
	az := resource.availability_zones

	value := [x | azi := az[_]; azi == "eu-west-2c"; x = azi]

	count(value) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elb[%s].availability_zones", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_elb[%s].availability_zones has AZ eu-west-2c", [name]),
		"keyActualValue": sprintf("aws_elb[%s].availability_zones AZ eu-west-2c is missing", [name]),
	}
}
