package com.initiative.banking.deployment;

import java.util.Properties;

public class StagingDeploymentConfig {

    private Properties deploymentProperties;

    public StagingDeploymentConfig() {
        deploymentProperties = new Properties();
        loadDefaultConfig();
    }

    // Load default configurations
    private void loadDefaultConfig() {
        deploymentProperties.setProperty("server", "staging-server");
        deploymentProperties.setProperty("port", "8080");
        deploymentProperties.setProperty("contextPath", "/app");
        deploymentProperties.setProperty("maxRetries", "3");
        deploymentProperties.setProperty("azureSubscription", "your-azure-subscription");
        deploymentProperties.setProperty("resourceGroup", "your-resource-group");
        deploymentProperties.setProperty("pipelineName", "your-pipeline-name");
    }

    /**
     * This method will provide the deployment configuration specific to the staging environment.
     * Summary: It configures environment-specific settings for staging deployment.
     *
     * @return Properties containing the deployment configuration for staging.
     */
    public Properties provideDeploymentConfig() {
        return deploymentProperties;
    }

    /**
     * This method validates the deployment configuration to ensure all necessary parameters are correctly set before the deployment process starts.
     * Summary: It ensures the deployment configuration is valid and ready for use.
     *
     * @throws Exception if any required configuration is invalid.
     */
    public void validateDeploymentConfig() throws Exception {
        if (deploymentProperties.getProperty("server") == null ||
            deploymentProperties.getProperty("port") == null ||
            deploymentProperties.getProperty("contextPath") == null ||
            deploymentProperties.getProperty("azureSubscription") == null ||
            deploymentProperties.getProperty("resourceGroup") == null ||
            deploymentProperties.getProperty("pipelineName") == null) {
            throw new Exception("Missing required deployment configuration parameters.");
        }

        try {
            int maxRetries = Integer.parseInt(deploymentProperties.getProperty("maxRetries"));
            if (maxRetries < 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            throw new Exception("Invalid value for 'maxRetries': " + deploymentProperties.getProperty("maxRetries"));
        }
    }
}
