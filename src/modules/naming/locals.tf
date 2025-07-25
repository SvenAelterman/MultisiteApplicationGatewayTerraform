locals {
  remove_segment_separators = length(local.resource_type_restrictions[var.resource_type].allowed_segment_separators) == 0 || var.remove_segment_separators
  instance_formatted        = format("%0${var.instance_formatted_length}d", var.instance)
}

locals {
  base_resource_type_restrictions = {
    UAMI = {
      max_length                 = 128
      lowercase                  = false
      allowed_segment_separators = ["-", "_"]
    }
    RG = {
      max_length                 = 90
      lowercase                  = false
      allowed_segment_separators = ["-", "_", "."]
    }
    PIP = {
      max_length                 = 80
      lowercase                  = false
      allowed_segment_separators = ["-", "_", "."]
    }
    KV = {
      max_length                 = 24
      lowercase                  = false
      allowed_segment_separators = ["-"]
    }
    VNET = {
      max_length                 = 64
      lowercase                  = false
      allowed_segment_separators = ["-", "_", "."]
    }
    NSG = {
      max_length                 = 80
      lowercase                  = false
      allowed_segment_separators = ["-", "_", "."]
    }
    Diag = {
      max_length                 = 80
      lowercase                  = false
      allowed_segment_separators = ["-"]
    }
  }

  additional_resource_type_restrictions = {
    AGW     = local.base_resource_type_restrictions.NSG
    RT      = local.base_resource_type_restrictions.NSG
    WFRules = local.base_resource_type_restrictions.NSG
  }

  resource_type_restrictions = merge(
    local.base_resource_type_restrictions,
    local.additional_resource_type_restrictions
  )

  short_regions = {
    australiacentral       = "acl"
    "Australia Central"    = "acl"
    australiacentral2      = "acl2"
    "Australia Central 2"  = "acl2"
    australiaeast          = "ae"
    "Australia East"       = "ae"
    australiasoutheast     = "ase"
    "Australia Southeast"  = "ase"
    brazilsouth            = "brs"
    "Brazil South"         = "brs"
    brazilsoutheast        = "bse"
    "Brazil Southeast"     = "bse"
    centraluseuap          = "ccy"
    "Central US EUAP"      = "ccy"
    canadacentral          = "cnc"
    "Canada Central"       = "cnc"
    canadaeast             = "cne"
    "Canada East"          = "cne"
    centralus              = "cus"
    "Central US"           = "cus"
    eastasia               = "ea"
    "East Asia"            = "ea"
    eastus2euap            = "ecy"
    "East US 2 EUAP"       = "ecy"
    eastus                 = "eus"
    "East US"              = "eus"
    eastus2                = "eus2"
    "East US 2"            = "eus2"
    francecentral          = "frc"
    "France Central"       = "frc"
    francesouth            = "frs"
    "France South"         = "frs"
    germanynorth           = "gn"
    "Germany North"        = "gn"
    germanywestcentral     = "gwc"
    "Germany West Central" = "gwc"
    centralindia           = "inc"
    "Central India"        = "inc"
    southindia             = "ins"
    "South India"          = "ins"
    westindia              = "inw"
    "West India"           = "inw"
    italynorth             = "itn"
    "Italy North"          = "itn"
    japaneast              = "jpe"
    "Japan East"           = "jpe"
    japanwest              = "jpw"
    "Japan West"           = "jpw"
    jioindiacentral        = "jic"
    "Jio India Central"    = "jic"
    jioindiawest           = "jiw"
    "Jio India West"       = "jiw"
    koreacentral           = "krc"
    "Korea Central"        = "krc"
    koreasouth             = "krs"
    "Korea South"          = "krs"
    northcentralus         = "ncus"
    "North Central US"     = "ncus"
    northeurope            = "ne"
    "North Europe"         = "ne"
    norwayeast             = "nwe"
    "Norway East"          = "nwe"
    norwaywest             = "nww"
    "Norway West"          = "nww"
    qatarcentral           = "qac"
    "Qatar Central"        = "qac"
    southafricanorth       = "san"
    "South Africa North"   = "san"
    southafricawest        = "saw"
    "South Africa West"    = "saw"
    southcentralus         = "scus"
    "South Central US"     = "scus"
    swedencentral          = "sdc"
    "Sweden Central"       = "sdc"
    swedensouth            = "sds"
    "Sweden South"         = "sds"
    southeastasia          = "sea"
    "Southeast Asia"       = "sea"
    switzerlandnorth       = "szn"
    "Switzerland North"    = "szn"
    switzerlandwest        = "szw"
    "Switzerland West"     = "szw"
    uaecentral             = "uac"
    "UAE Central"          = "uac"
    uaenorth               = "uan"
    "UAE North"            = "uan"
    uksouth                = "uks"
    "UK South"             = "uks"
    ukwest                 = "ukw"
    "UK West"              = "ukw"
    westcentralus          = "wcus"
    "West Central US"      = "wcus"
    westeurope             = "we"
    "West Europe"          = "we"
    westus                 = "wus"
    "West US"              = "wus"
    westus2                = "wus2"
    "West US 2"            = "wus2"
    westus3                = "wus3"
    "West US 3"            = "wus3"
    usdodcentral           = "udc"
    "USDoD Central"        = "udc"
    usdodeast              = "ude"
    "USDoD East"           = "ude"
    usgovarizona           = "uga"
    "USGov Arizona"        = "uga"
    usgoviowa              = "ugi"
    "USGov Iowa"           = "ugi"
    usgovtexas             = "ugt"
    "USGov Texas"          = "ugt"
    usgovvirginia          = "ugv"
    "USGov Virginia"       = "ugv"
    usnateast              = "exe"
    "USNat East"           = "exe"
    usnatwest              = "exw"
    "USNat West"           = "exw"
    usseceast              = "rxe"
    "USSec East"           = "rxe"
    ussecwest              = "rxw"
    "USSec West"           = "rxw"
    chinanorth             = "bjb"
    "China North"          = "bjb"
    chinanorth2            = "bjb2"
    "China North 2"        = "bjb2"
    chinanorth3            = "bjb3"
    "China North 3"        = "bjb3"
    chinaeast              = "sha"
    "China East"           = "sha"
    chinaeast2             = "sha2"
    "China East 2"         = "sha2"
    chinaeast3             = "sha3"
    "China East 3"         = "sha3"
    germanycentral         = "gec"
    "Germany Central"      = "gec"
    germanynortheast       = "gne"
    "Germany North East"   = "gne"
  }
}
