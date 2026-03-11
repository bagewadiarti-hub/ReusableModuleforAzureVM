// Jenkinsfile
// CI/CD Pipeline - Auto installs Terraform, runs Init → Plan → Apply automatically
// No manual parameters needed - just push to GitHub and pipeline runs!

pipeline {

    agent any

    // ── Auto-install Terraform via Jenkins Tool ──────────────────────────────
    tools {
        terraform 'Terraform'   // matches the name you set in Jenkins Global Tools
    }

    // ── Environment Variables (Azure credentials from Jenkins) ───────────────
    environment {
        ARM_CLIENT_ID           = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET       = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID     = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID           = credentials('AZURE_TENANT_ID')
        TF_VAR_ssh_public_key   = credentials('SSH_PUBLIC_KEY')
    }

    stages {

        // ── Stage 1: Checkout Code from GitHub ──────────────────────────────
        stage('Checkout') {
            steps {
                echo '📥 Checking out code from GitHub...'
                checkout scm
            }
        }

        // ── Stage 2: Verify Terraform is Available ───────────────────────────
        stage('Verify Terraform') {
            steps {
                echo '🔍 Verifying Terraform installation...'
                bat 'terraform version'
            }
        }

        // ── Stage 3: Terraform Init ──────────────────────────────────────────
        stage('Terraform Init') {
            steps {
                echo '⚙️ Initializing Terraform and connecting to Azure remote backend...'
                bat 'terraform init -input=false'
            }
        }

        // ── Stage 4: Terraform Validate ──────────────────────────────────────
        stage('Terraform Validate') {
            steps {
                echo '✅ Validating Terraform configuration files...'
                bat 'terraform validate'
            }
        }

        // ── Stage 5: Terraform Format Check ─────────────────────────────────
        stage('Terraform Format Check') {
            steps {
                echo '🎨 Checking Terraform code formatting...'
                // -check flag: fails if formatting issues found (does not modify files)
                bat 'terraform fmt -check -recursive'
            }
        }

        // ── Stage 6: Terraform Plan ──────────────────────────────────────────
        stage('Terraform Plan') {
            steps {
                echo '📋 Running Terraform Plan - previewing changes...'
                bat 'terraform plan -out=tfplan -input=false'
            }
            post {
                always {
                    // Save plan file as Jenkins build artifact for reference
                    archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
                }
            }
        }

        // ── Stage 7: Terraform Apply ─────────────────────────────────────────
        stage('Terraform Apply') {
            steps {
                echo '🚀 Applying Terraform changes to Azure...'
                // Uses the saved plan file - no prompt needed (-auto-approve)
                bat 'terraform apply -input=false -auto-approve tfplan'
            }
        }

        // ── Stage 8: Show Outputs ────────────────────────────────────────────
        stage('Show Outputs') {
            steps {
                echo '📤 Terraform Outputs (VM IDs and IP Addresses):'
                bat 'terraform output'
            }
        }
    }

    // ── Post-build Notifications ─────────────────────────────────────────────
    post {
        success {
            echo '''
            ✅ Pipeline completed successfully!
            ✅ All Azure VMs (dev + staging) are deployed.
            ✅ Check outputs above for VM IDs and IP addresses.
            '''
        }
        failure {
            echo '''
            ❌ Pipeline failed!
            ❌ Check the stage logs above to find the error.
            ❌ Common issues:
               - Azure credentials not set in Jenkins
               - Storage account name wrong in main.tf backend block
               - Terraform fmt formatting errors in code
            '''
        }
        always {
            echo '🧹 Pipeline finished. Cleaning workspace...'
            cleanWs()
        }
    }
}
