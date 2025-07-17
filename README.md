# Azure Application Gateway Terraform Module

This Terraform configuration creates a comprehensive Azure Application Gateway deployment using Azure best practices and the Azure Verified Module pattern.

## Features

- **Azure Application Gateway v2** with zone redundancy
- **Web Application Firewall (WAF)** support (optional)
- **Autoscaling** capabilities
- **SSL/TLS termination** with Key Vault integration
- **Managed Identity** for secure certificate access
- **Health probes** for backend monitoring
- **Network Security Groups** with appropriate rules
- **Multiple backend pools** and routing rules
- **Zone redundant** deployment across availability zones

## Creates

- Key Vault
- TLS certificate(s) in Key Vault
- Public IP address for the Application Gateway
- Virtual Network subnet (in existing virtual network)
- Network Security Groups with appropriate rules
- User-assigned Managed Identity
- DNS records if DNS is hosted in Azure public DNS zones
- Application Gateway with frontends, listeners, certificates (from KV), routing rules, backend settings, etc.

## Prerequisites

- Azure CLI or Azure PowerShell
- Terraform >= 1.0
- Azure subscription with appropriate permissions
- (Optional) SSL certificates in Azure Key Vault

## Quick Start

Pending
