import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/article.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/screens/WebView.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';



class ArticlesNewsWidget extends StatefulWidget {
  final Article articles;

  const ArticlesNewsWidget({
    super.key,
    required this.articles,
  });

  @override
  State<ArticlesNewsWidget> createState() => _ArticlesNewsWidgetState();
}

class _ArticlesNewsWidgetState extends State<ArticlesNewsWidget> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(
              articles: widget.articles,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:  provider.isDarkMode()
              ? MyTheme.primaryDark
              : MyTheme.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: widget.articles.urlToImage ?? '',
                placeholder: (context, url) {
                  return const CircularProgressIndicator();
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Text(
              widget.articles.source?.id?.toUpperCase() ?? '',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xff79828B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.articles.description?.toUpperCase() ?? '',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xff42505C),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                widget.articles.publishedAt?.toUpperCase().substring(0, 10) ??
                    '',
                style: GoogleFonts.montserrat(
                  color: const Color(0xffA3A3A3),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
