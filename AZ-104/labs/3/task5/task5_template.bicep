param disk_name string = 'az104-disk5'

resource disk_name_resource 'Microsoft.Compute/disks@2026-03-02' = {
  name: disk_name
  location: 'eastus'
  sku: {
    name: 'StandardSSD_LRS'
    tier: 'Standard'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 32
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
    networkAccessPolicy: 'AllowAll'
    publicNetworkAccess: 'Enabled'
    dataAccessAuthMode: 'None'
  }
}
