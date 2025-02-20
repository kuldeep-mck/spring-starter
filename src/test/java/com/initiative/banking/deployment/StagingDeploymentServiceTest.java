package com.initiative.banking.deployment;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class StagingDeploymentServiceTest {

    @Mock
    private StagingDeploymentConfig stagingDeploymentConfig;

    @Mock
    private BuildArtifactService buildArtifactService;

    @Mock
    private DeploymentTriggerService deploymentTriggerService;

    @InjectMocks
    private StagingDeploymentService stagingDeploymentService;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testDeployToStaging() {
        DeploymentConfig deploymentConfig = new DeploymentConfig();
        when(stagingDeploymentConfig.provideDeploymentConfig()).thenReturn(deploymentConfig);
        
        doNothing().when(buildArtifactService).createBuildArtifacts();
        doNothing().when(deploymentTriggerService).triggerDeployment(deploymentConfig);

        assertDoesNotThrow(() -> stagingDeploymentService.deployToStaging());

        verify(stagingDeploymentConfig, times(1)).provideDeploymentConfig();
        verify(buildArtifactService, times(1)).createBuildArtifacts();
        verify(deploymentTriggerService, times(1)).triggerDeployment(deploymentConfig);
    }

    @Test
    public void testRollbackStagingDeployment() {
        doNothing().when(deploymentTriggerService).rollbackDeployment();

        assertDoesNotThrow(() -> stagingDeploymentService.rollbackStagingDeployment());

        verify(deploymentTriggerService, times(1)).rollbackDeployment();
    }
}
