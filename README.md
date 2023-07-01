# mpt30
Test for mpt30

Запуск в Docker:

docker build -t mpt .
docker run -dit --name mtp-container -p 221:22 --gpus all --restart unless-stopped mtp:latest
docker container attach mpt


Youtube: https://www.youtube.com/watch?v=Ii3m8P3pp1c

Commnads:
conda create -n mpt30 python=3.10.0
conda activate mpt30

https://github.com/abacaj/mpt-30B-inference  ->  git clone
pip install -r requirements.txt

Скачиваем модель: https://huggingface.co/TheBloke/mpt-30B-chat-GGML

python inference.py
