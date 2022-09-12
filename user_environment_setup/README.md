# Azure User Management

A modularized approach to Terraform for Azure

## Overview

Manage many users provision required resources.

The user management security group can have associated Azure AD roles, if supported by the Tenant AD License.

Each user is provisioned one of more Resource Groups with zero or more associated roles and a Storage Account with a File Share.

A bastion host and Linux VM is provisioned when

- locals `bastion_host_support` is `true`
- locals resource_groups map attribute `bastion` is true

## Cloning and Pulling Requirement

When running `git clone` or `git pull` on this repository be sure to add the `--recurse-submodules` flag.
