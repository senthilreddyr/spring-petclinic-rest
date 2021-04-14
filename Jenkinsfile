podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'packer',image: 'senthilreddy/anpm:latest', ttyEnabled: true, command: 'cat'),
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
  ) {
    node('mypod') {
        stage('Get latest version of code') {
                script{
                   def scmVar =  checkout([
                        $class: 'GitSCM', branches: scm.branches,
                        extensions: scm.extensions + [[$class: 'CleanBeforeCheckout', deleteUntrackedNestedRepositories: true]],
                        userRemoteConfigs: scm.userRemoteConfigs])
                }
            }
      stage('Packer') {
        container('packer') {
          withCredentials([usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID'),
          usernamePassword(credentialsId: 'DB_PASSWORD_CRED_ID', usernameVariable: 'db_username', passwordVariable: 'db_password')
          ]){
            sh "mvn clean package"
            sh "packer build ./packer.json"
            AMI_ID=sh(script:'cat manifest.json | jq -r .builds[0].artifact_id |  cut -d\':\' -f2',returnStdout: true)
          }
        }
      }
    if (currentBuild.currentResult == 'SUCCESS') {
      stage('Trigger deploy') 
          script {
            def USER_INPUT = input(
                  message: 'User input required - Some Yes or No question?',
                  parameters: [
                          [$class: 'ChoiceParameterDefinition',
                            choices: ['no','yes'].join('\n'),
                            name: 'input',
                            description: 'Menu - select box option']
                  ])
          if( "${USER_INPUT}" == "yes"){
              echo "${AMI_ID}"
              build job: 'pet_be_deploy', parameters: [string(name: 'ami_id', value: "${AMI_ID}")],
          } else {
              echo "No user input selected"
          }
        }
      }
    }
  }
