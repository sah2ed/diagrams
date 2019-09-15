pip3 install -r requirements.txt

## Clean Training Data
python3 -m src.main clean \
        --input_dir=../challenge-data/training-data \
        --output_dir=./clean_dir \
        --corrections=./data/corrections.csv

## Group LAS files by LNAM
python3 -m src.main aggregate-curves \
        --input_dir=../challenge-data/training-data \
        --group_dir=./group_dir \
        --curve_list_dir=./curve_list_dir

## Analyze LNAM and its associated curve attributes
python3 -m src.main process-curves \
        --group_dir=./group_dir \
        --curve_dir=./curve_dir \
        --n=10000 \
        --n_output=./most_common_lnam.xlsx

## Analyze SRVC and its associated LNAMs
python3 -m src.main process-srvc \
        --group_dir=./group_dir \
        --srvc_dir=./srvc_dir

## Generate Truth File
python3 -m src.main truth-file \
        --input_dir=../challenge-data/training-data \
        --truth_file=./00truth.csv

## Run RandomForest Prediction
python3 -m src.main run-prediction \
        --training_files_directory=../challenge-data/training-data \
        --testing_files_directory=../challenge-data/training-data \
        --predictions_output_file=./01prediction.csv

## Run Prediction Analysis #1st     
python3 -m src.main prediction-analysis \
        --truth_file=./00truth.csv \
        --predictions_output_file=./01prediction.csv \
        --analysis_output=./02analysis.xls        

## Train TensorFlow models by Curve Attribute and Vendor Name
python3 -m src.main curve-train \
        --training_files_directory=../challenge-data/training-data \
        --model_dir=./model_dir
    
### Predict LNAM using TensorFlow models
python3 -m src.main curve-predict \
        --testing_files_directory=../challenge-data/training-data \
        --model_dir=./model_dir \
        --predictions_output_file=./03prediction.csv
        
## Run Prediction Analysis #2nd
python3 -m src.main prediction-analysis \
        --truth_file=./00truth.csv \
        --predictions_output_file=./03prediction.csv \
        --model_dir=./model_dir \
        --analysis_output=./04analysis.xls       
