# RHEL 9 vSphere for Packer

Supply values for the empty vars in `esxauth.auto.pkrvars.hcl`.

Supply a valid path for `iso_url` in `sources.auto.pkrvars.hcl` in URL format.  The SHA256 sum was valid for `rhel-9.2-x86_64-dvd.iso` at the time this was pushed.  If the sum does not match your download, the recommendation is to retrieve the correct SHA256 sum from Red Hat and use that to verify your ISO.

In `supportfiles/rhel_setup.sh` replace the `<USERNAME>` and `<PASSWORD>` with valid credentials to register with Red Hat.  If you use another entitlement authority, you can change the `subscription-manager` lines to fit with your organization.

After filling out those values, you should be able to run `packer build .` and build a RHEL 9 VM that is able to be deployed by Morpheus.  The default name will be `rhel-9-x86_64-<current date>`

This was tested against Morpheus 6.1.1 but should be backwards compatible with all versions capable of supporting RHEL 9, including 6.0.2.  
