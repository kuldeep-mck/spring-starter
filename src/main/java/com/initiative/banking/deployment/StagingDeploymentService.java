# azure-pipelines.yml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

variables:
  artifactPath: '$(System.DefaultWorkingDirectory)/drop'

steps:
- task: Maven@3
  inputs:
    mavenPomFile: 'pom.xml'
    goals: 'clean package'

- task: CopyFiles@2
  inputs:
    SourceFolder: '$(System.DefaultWorkingDirectory)/target'
    Contents: '**/*'
    TargetFolder: '$(artifactPath)'

- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: '$(artifactPath)'
    artifactName: 'drop'
    publishLocation: 'Container'

- task: AzureAppServiceDeploy@4
  inputs:
    ConnectionType: 'AzureRM'
    azureSubscription: '<Azure Subscription>'
    appType: 'webApp'
    WebAppName: '<App Service Name>'
    package: '$(artifactPath)/**/*.war'
    deploymentMethod: 'runFromPackage'
