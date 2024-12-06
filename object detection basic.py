import cv2
import numpy as np

class ObjectDetection:
    def __init__(self, capture_index):
        self.capture_index = capture_index
        self.device = 'gpu'
        print("Using Device:", self.device)
        self.classes = self.load_classes()
        self.net, self.output_layers = self.load_model()

    def load_classes(self):
        with open(r"E:\KJ Somaiya\Internship\yolo\coco.names", "r") as f:
            classes = [line.strip() for line in f.readlines()]
        return classes

    def load_model(self):
        net = cv2.dnn.readNet(r"E:\KJ Somaiya\Internship\yolo\yolov3.weights",
                              r"E:\KJ Somaiya\Internship\yolo\yolov3.cfg")
        layer_names = net.getLayerNames()
        output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]
        return net, output_layers

    def predict(self, frame):
        blob = cv2.dnn.blobFromImage(frame, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
        self.net.setInput(blob)
        outputs = self.net.forward(self.output_layers)
        return outputs

    def plot_boxes(self, outputs, frame):
        height, width, _ = frame.shape
        class_ids = []
        confidences = []
        boxes = []
        for output in outputs:
            for detect in output:
                scores = detect[5:]
                class_id = np.argmax(scores)
                confidence = scores[class_id]
                if confidence > 0.5:
                    center_x = int(detect[0] * width)
                    center_y = int(detect[1] * height)
                    w = int(detect[2] * width)
                    h = int(detect[3] * height)
                    x = int(center_x - w / 2)
                    y = int(center_y - h / 2)
                    boxes.append([x, y, w, h])
                    confidences.append(float(confidence))
                    class_ids.append(class_id)

        indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.4)
        font = cv2.FONT_HERSHEY_PLAIN
        colors = np.random.uniform(0, 255, size=(len(boxes), 3))
        if len(indexes) > 0:
            for i in indexes.flatten():
                x, y, w, h = boxes[i]
                label = str(self.classes[class_ids[i]])
                confidence = str(round(confidences[i], 2))
                color = colors[i]
                cv2.rectangle(frame, (x, y), (x + w, y + h), color, 2)
                cv2.putText(frame, f"{label} {confidence}", (x, y + 30), font, 2, (255, 255, 255), 2)

        cv2.imshow("Frame", frame)
        cv2.waitKey(1)

    def start_detection(self):
        cap = cv2.VideoCapture(self.capture_index)
        while True:
            ret, frame = cap.read()
            if ret:
                outputs = self.predict(frame)
                self.plot_boxes(outputs, frame)
            else:
                break

        cap.release()
        cv2.destroyAllWindows()

# Initialize the class and start object detection
detector = ObjectDetection(0)
detector.start_detection()