# Azure User Management

A modularized approach to Terraform for Azure

## Overview

Create many users and assign them to a new security group.

The security group can have associated Azure AD roles, if supported by the associated AD License.

Each user is provisioned one of more Resource Groups with zero or more associated roles and a Storage Account with a File Share.

## Cloning and Pulling Requirement

When running `git clone` or `git pull` on this repository be sure to add the `--recurse-submodules` flag.
