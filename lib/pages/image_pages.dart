import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ImagePage extends StatefulWidget {
  // final FirebaseFile file;
  final String myUrl;
  const ImagePage({
    Key? key,
    required this.myUrl,
  }) : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with SingleTickerProviderStateMixin{
    late TransformationController controller;
    TapDownDetails? tapDownDetails;

    late AnimationController animationController;
    Animation<Matrix4>? animation;
    double _scale = 1.0;
    double _previousScale = 1.0;
    int _quarterTurns = 0;

    final double minScale = 1;
    final double maxScale = 4;

    @override
    void initState(){
      super.initState();
      controller = TransformationController();
      animationController = AnimationController(vsync: this,
      duration:  const Duration(milliseconds: 300))..addListener(() {
        controller.value = animation!.value;
      });
    }

    @override
    void dispose(){
      controller.dispose();
      animationController.dispose();
      super.dispose();
    }
  @override
  Widget build(BuildContext context) {
    // final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    
    return Scaffold(
      appBar: AppBar(
        // title: Text(file.name),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.file_download),
        //     onPressed: () async {
        //       await FirebaseApi.downloadFile(file.ref);

        //       final snackBar = SnackBar(
        //         content: Text('Downloaded ${file.name}'),
        //       );
        //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //     },
        //   ),
        //   const SizedBox(width: 12),
        // ],
      ),
      body: 
          Center(
            child: GestureDetector(
              onScaleStart: (ScaleStartDetails details){
                _previousScale = _scale;
                setState(() {});
              },
              onScaleUpdate: (ScaleUpdateDetails details){
                _scale = _previousScale * details.scale*2;
                  setState(() {});
              },
              onScaleEnd: (ScaleEndDetails details){
                _previousScale = 1.0;
                setState(() {});
              },
              onDoubleTap: (){
                final position = tapDownDetails!.localPosition;
                const double scalee = 2.5;
                final x = -position.dx * (scalee -1);
                final y = -position.dy * (scalee -1);
                
                final zoomed = Matrix4.identity()
                ..translate(x,y)
                ..scale(scalee);

                final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();
                animation = Matrix4Tween(
                  begin: controller.value,
                  end: end,
                ).animate(CurveTween(curve: Curves.easeOut).animate(animationController));

                animationController.forward(from: 0);
              },
              onDoubleTapDown: (details) => tapDownDetails = details,
              child: RotatedBox(
                quarterTurns: _quarterTurns,
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    minScale: minScale,
                    maxScale: maxScale,
                transformationController: controller,
                    child: Image.network(
                      widget.myUrl,
                      // height: double.infinity,
                      fit: BoxFit.contain,
                                    ),
                  )
                ),
              ),
            ),
          ),
          floatingActionButton : FloatingActionButton(

              child: const Icon(Icons.rotate_90_degrees_ccw_rounded),
            onPressed : (){
              setState(() {
                if(_quarterTurns >= 4){
                _quarterTurns = 0;
              }
              _quarterTurns++;
              });
              
            }
          )
    );
  }
}