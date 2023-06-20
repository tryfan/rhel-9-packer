# RHEL 9 vSphere for Packer

Supply values for the empty vars in `esxauth.auto.pkrvars.hcl`.

Supply a valid path for `iso_url` in `sources.auto.pkrvars.hcl` in URL format.

In `supportfiles/rhel_setup.sh` replace the `<USERNAME>` and `<PASSWORD>` with valid credentials to register with Red Hat.  If you use another entitlement authority, you can change the `subscription-manager` lines to fit with your organization.

After filling out those values, you should be able to run `packer build .` and build a RHEL 9 VM that is able to be deployed by Morpheus.  This was tested against Morpheus 6.1.1 but should be backwards compatible with all versions capable of supporting RHEL 9, including 6.0.2.  
