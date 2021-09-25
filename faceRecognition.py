import cv2
import numpy as np
import insightface
from insightface.app import FaceAnalysis
from insightface.data import get_image as ins_get_image

class FaceRecognition:
    def __init__(self) -> None:
        self.app = FaceAnalysis()
        # ctx id, <0 means using cpu
        self.app.prepare(ctx_id=0, det_size=(640, 640))

    def get_embeddings(self,image_file):
        """
        Generates face embedding of the image_file given
        """
        # img = ins_get_image('myPic')
        img = cv2.imread(image_file)
        faces = self.app.get(img)
        rimg = self.app.draw_on(img, faces)
        cv2.imwrite("./output.jpg", rimg)
        # print(faces)
        # print(type(faces))
        print(f"BBOX{faces[0]['bbox']}")
        # print(f"kps{faces[0]['kps']}")
        # # print(f"Landmark_3d{faces[0]['landmark_3d_68']}")
        # # print(f"Landmark_2d{faces[0]['landmark_2d_106']}")
        # print(f"Gender{faces[0]['gender']}")
        # print(f"Age{faces[0]['age']}")
        print(f"embedding{faces[0]['embedding']}")
        return faces
        

if __name__ == "__main__":
    FR=FaceRecognition()
    face_embeddings=FR.get_embeddings('myPic.jpg')
    print(face_embeddings)



