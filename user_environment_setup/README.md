# Azure User Management

A modularized approach to Terraform for Azure

## Overview

Manage many users and provision required resources.

The user management security group can have associated Azure AD roles, if supported by the Tenant AD License.

Each user is provisioned one of more Resource Groups with zero or more associated roles and a Storage Account with a File Share.

A bastion host and Linux or Windows VM is provisioned when

- locals `bastion_host_support` is `true`
- locals resource_groups map attribute `bastion` is true
- locals resource_groups map attribute `bastion_host_type` is either `lin` for `linux` or `win` for `windows`

> Review `locals_user_environment_setup.tf` for more details

A Service Principal per user is provisioned when

- locals `per_user_service_principle` is `true`
  - must be set to `true` to support Bastion Sharable Links. Bastion Shareable Links are created using each user's Service Principal

Set Service Principal Role with

- locals `per_user_service_principle_role` = "RoleName"

## Cloning and Pulling Requirement

When running `git clone` or `git pull` on this repository be sure to add the `--recurse-submodules` flag.
