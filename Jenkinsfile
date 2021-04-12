podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'packer',image: 'senthilreddy/anpm:latest', ttyEnabled: true, command: 'cat'),
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
  ) {
    node('mypod') {
        def DB_PASSWORD_CRED_ID = 'DB_PASSWORD_PROD'
        stage('Get latest version of code') {
                script{
                   def scmVar =  checkout([
                        $class: 'GitSCM', branches: scm.branches,
                        extensions: scm.extensions + [[$class: 'CleanBeforeCheckout', deleteUntrackedNestedRepositories: true]],
                        userRemoteConfigs: scm.userRemoteConfigs])
                }
        }
    
      stage('RunAWSCMD') {
        container('packer') {
          withCredentials([usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID'),
          usernamePassword(credentialsId: 'DB_PASSWORD_CRED_ID', usernameVariable: 'db_username', passwordVariable: 'db_password')
          ]){
            ./mvnw clean package
            // db_url=sh(script:'aws rds --region ap-south-1 describe-db-instances --query "DBInstances[*].Endpoint.Address" --output text',returnStdout: true)
            sh "packer build ./packer.json"
          }

        }
      }
    }
}
