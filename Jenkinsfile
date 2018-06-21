#!groovy
// Script to launch Watchdog tests on every supported platform.

// Pipeline properties
properties([
    disableConcurrentBuilds(),
    pipelineTriggers([[$class: 'GitHubPushTrigger']]),
    [$class: 'BuildDiscarderProperty', strategy:
        [$class: 'LogRotator', daysToKeepStr: '60', numToKeepStr: '60', artifactNumToKeepStr: '1']],
    [$class: 'SchedulerPreference', preferEvenload: true],
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
    [$class: 'ParametersDefinitionProperty', parameterDefinitions: [
        [$class: 'StringParameterDefinition',
            name: 'PYTEST_ADDOPTS',
            defaultValue: '',
            description: 'Extra command line options for pytest. Useful for debugging: --capture=no'],
        [$class: 'BooleanParameterDefinition',
            name: 'CLEAN_WORKSPACE',
            defaultValue: false,
            description: 'Clean the entire workspace before doing anything.']
    ]]
])

// Jenkins slaves we will build on
slaves = ['OSXSLAVE-DRIVE', 'SLAVE', 'WINSLAVE']
labels = [
    'OSXSLAVE-DRIVE': 'macOS',
    'SLAVE': 'GNU/Linux',
    'WINSLAVE': 'Windows'
]
builders = [:]

// GitHub stuff
repos_url = 'https://github.com/nuxeo/watchdog3'
repos_git = 'https://github.com/nuxeo/watchdog3.git'
status_msg = [
    'FAILURE': 'Failed to build on Nuxeo CI',
    'PENDING': 'Building on on Nuxeo CI',
    'SUCCESS': 'Successfully built on Nuxeo CI'
]

def github_status(status) {
    step([$class: 'GitHubCommitStatusSetter',
        reposSource: [$class: 'ManuallyEnteredRepositorySource', url: repos_url],
        contextSource: [$class: 'ManuallyEnteredCommitContextSource', context: 'ci/qa.nuxeo.com'],
        statusResultSource: [$class: 'ConditionalStatusResultSource',
            results: [[$class: 'AnyBuildResult',
                message: status_msg.get(status), state: status]]]])
}

def checkout_custom() {
    checkout([$class: 'GitSCM',
        branches: [[name: env.BRANCH_NAME]],
        browser: [$class: 'GithubWeb', repoUrl: repos_url],
        doGenerateSubmoduleConfigurations: false,
        extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'sources']],
        submoduleCfg: [],
        userRemoteConfigs: [[url: repos_git]]])
}

for (def x in slaves) {
    // Need to bind the label variable before the closure - can't do 'for (slave in slaves)'
    def slave = x
    def osi = labels.get(slave)

    // Create a map to pass in to the 'parallel' step so we can fire all the builds at once
    builders[slave] = {
        node(slave) {
            withEnv(["WORKSPACE=${pwd()}"]) {
                if (params.CLEAN_WORKSPACE) {
                    deleteDir()
                }

                try {
                    stage(osi + ' Checkout') {
                        try {
                            dir('sources') {
                                deleteDir()
                            }
                            github_status('PENDING')
                            checkout_custom()
                        } catch(e) {
                            currentBuild.result = 'UNSTABLE'
                            throw e
                        }
                    }

                    stage(osi + ' Tests') {
                        env.PYTHON_DRIVE_VERSION = '3.6.5'

                        dir('sources') {
                            try {
                                if (osi == 'Windows') {
                                    bat(/powershell ".\tools\jenkins.ps1"/)
                                } else {
                                    sh 'chmod +x tools/jenkins.sh'
                                    sh 'tools/jenkins.sh'
                                }
                            } catch(e) {
                                currentBuild.result = 'FAILURE'
                                throw e
                            }
                        }
                        currentBuild.result = 'SUCCESS'
                    }
                } finally {
                    // We use catchError to not let notifiers and recorders change the current build status
                    catchError {
                        // Update GitHub status whatever the result
                        github_status(currentBuild.result)

                        // Update revelant Jira issues only if we are working on the master branch
                        if (env.BRANCH_NAME == 'master') {
                            step([$class: 'JiraIssueUpdater',
                                issueSelector: [$class: 'DefaultIssueSelector'],
                                scm: scm, comment: osi])
                        }
                    }
                }
            }
        }
    }
}

timeout(30) {
    timestamps {
        parallel builders
    }
}
