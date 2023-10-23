terraform-aws-rds-private-subnet-db-provisioner
===============================================

Terraform module to provision databases / users / groups / permissions in an RDS
instance, even when the instance is in a private subnet.

Implementation
--------------

We create a Lambda function in the database subnet, attached to a security group
that grants access to the RDS instance.  Database credentials are read into the
function from a Secrets Manager secret.  The function calls Ansible (because 
Ansible is good at managing RDS databases / users / groups / permissions) and 
executes the playbook you supply.

### Caveat

Yes, you _could_ do other things with Ansible from this module.  However you 
should not.  

Terraform, particularly when running from Terraform Cloud, is unable to connect 
to an RDS instance in a private subnet. Therefore we must use a Lambda instead.  

Everything that you _can_ do in Terraform directly, you should do.


Usage
-----

TBD


License
-------

This is Free Software, released under the terms of the Simplified BSD license.

