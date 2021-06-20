import 'package:flutter/material.dart';

class HeaderCuadrado extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70)),
        color: Colors.blueGrey,
      ),
      child: null,
    );
  }
}

class HeaderDiagonal extends StatelessWidget {

    bool _modoOscuro = false;

  HeaderDiagonal(bool modo){
    _modoOscuro = modo;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderDiagonalPainter(_modoOscuro) ,),
            );
          }
        }
        
class _HeaderDiagonalPainter extends CustomPainter {

  bool _modoOscuro = false;

  _HeaderDiagonalPainter(bool modo){
    _modoOscuro = modo;
  }

  @override
  void paint(Canvas canvas, Size size) {
      final paint = Paint();
      
      _modoOscuro
      ?
        paint.color = Colors.blueGrey
      :
        paint.color = Colors.blueGrey[800];

      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 5;

      final path = new Path();
      path.lineTo(0,size.height * 0.65);
      //path.quadraticBezierTo(size.width*0.5,size.height*0.75,size.width*0.9,size.height * 0.5);
      path.quadraticBezierTo(size.width*0.11,size.height*0.45,size.width*0.27,size.height * 0.55);

      path.quadraticBezierTo(size.width*0.5,size.height*0.7,size.width*0.9,size.height * 0.5);

      path.quadraticBezierTo(size.width*0.99,size.height*0.45,size.width,size.height * 0.55);
      path.lineTo(size.width,0);
      canvas.drawPath(path,paint);

  }

  @override
  bool shouldRepaint(_HeaderDiagonalPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_HeaderDiagonalPainter oldDelegate) => false;
}