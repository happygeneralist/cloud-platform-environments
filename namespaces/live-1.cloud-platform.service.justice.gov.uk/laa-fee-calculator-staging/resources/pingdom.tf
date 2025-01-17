provider "pingdom" {
}

resource "pingdom_check" "laa-fee-calculator-staging" {
  type                     = "http"
  name                     = "LAA fee calculator staging - ping"
  host                     = "staging.${var.domain}"
  resolution               = 1
  notifywhenbackup         = true
  sendnotificationwhendown = 6
  notifyagainevery         = 0
  url                      = "/ping.json"
  encryption               = true
  port                     = 443
  tags                     = "businessunit_${var.business-unit},application_laa-fee-calculator,component_ping,isproduction_${var.is-production},environment_${var.environment-name},infrastructuresupport_laa-fee-calculator"
  probefilters             = "region:EU"
  integrationids           = [116478]
}

