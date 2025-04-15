# Paths do not work here...
#java -jar StateSynth/5GBaseChecker_Statelearner/out/artifacts/5GBaseChecker_Statelearner_jar/5GBaseChecker_Statelearner.jar fgue.properties
DRIVER=$1
if [ -z "$DRIVER" ]; then
  echo "Usage: $0 <driver [srsue|oai]>"
  exit 1
fi

./load_learner_config.sh ./learner_config/Sequential_learning/$DRIVER.properties fgue.properties
java -cp out/artifacts/5GBaseChecker_Statelearner_jar/5GBaseChecker_Statelearner.jar org.example.uelearner.Learner fgue.properties
