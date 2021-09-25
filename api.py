from flask import Flask
from flask_restful import Resource, Api, reqparse
import werkzeug
# import time
# from infer import Inferance
from faceRecognition import FaceRecognition
import urllib.request as urllib_req
import os


app = Flask(__name__)
api = Api(app)

class ServerStatus(Resource):
    def get(self):
        return {'status': 'active', 'msg':'Face Recognition Api is active'}

class FaceEmbeddingUrl(Resource):
    def post(self):
        img_path="uploaded.jpeg"
        parser = reqparse.RequestParser()
        parser.add_argument(
            'Url',
            type=str,
            required=True,help='Url for image where face embedding is generated,Url is required')
        args = parser.parse_args()
        urllib_req.urlretrieve(args['Url'],img_path)
        print("Image URL Received")
        FR=FaceRecognition()
        embeddings = FR.get_embeddings(img_path)
        return {
            'status': 'success',
            'msg':'face embedding finished',
            'embedding':embeddings[0]['embedding'],
            'bbox':embeddings[0]['bbox']}
class FaceEmbeddingFile(Resource):
    def post(self):
        img_path="uploaded.jpg"
        parser = reqparse.RequestParser()
        parser.add_argument(
            'File',
            type=werkzeug.datastructures.FileStorage,
            location='files',required=True,help='image file is required')
        args = parser.parse_args()
        image_file = args['File']
        image_file.save(img_path)
        print("Image File Received")
        FR=FaceRecognition()
        embeddings = FR.get_embeddings(img_path)
        return {
            'status': 'success',
            'msg':'face embedding finished',
            'embedding':embeddings[0]['embedding'].tolist(),
            'bbox':embeddings[0]['bbox'].tolist()
            }

api.add_resource(ServerStatus, '/status/')
api.add_resource(FaceEmbeddingUrl, '/face_embed/url/')
api.add_resource(FaceEmbeddingFile, '/face_embed/file/')



if __name__ == '__main__':
    # app.run(debug=True)
    app.run(host="0.0.0.0",port=int(os.environ.get("PORT", 8080)),debug=True)
