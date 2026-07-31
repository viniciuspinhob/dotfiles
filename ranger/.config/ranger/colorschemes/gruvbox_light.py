from ranger.gui.color import *
from ranger.colorschemes.default import Default


class Scheme(Default):
    progress_bar_color = 100

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.reset:
            return (fg, bg, attr)

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = 229
            if context.border:
                fg = 229
            if context.media:
                if context.image:
                    fg = 100
                else:
                    fg = 130
            if context.container:
                fg = 130
            if context.directory:
                if context.main_column:
                    fg = 136
                else:
                    fg = 24
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = 100
            if context.socket:
                fg = 130
                attr |= bold
            if context.fifo:
                fg = 130
            if context.device:
                fg = 130
            if context.link:
                fg = 24 if context.good else 88
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 100
            if not context.selected and (context.cut or context.copied):
                fg = 229
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    if not context.directory:
                        fg = 100
            if context.badinfo:
                if attr & reverse:
                    bg = 88
                else:
                    fg = 88

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 100 if context.bad else 100
            elif context.directory:
                fg = 24
            elif context.tab:
                if context.good:
                    bg = 100
            elif context.link:
                fg = 24

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 100
                elif context.bad:
                    fg = 88
            if context.marked:
                attr |= bold | reverse
                fg = 100
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 88
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 24
                attr &= ~bold
            if context.vcscommit:
                fg = 100
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 24
            if context.selected:
                attr |= bold
            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 88
            elif context.vcschanged:
                fg = 130
            elif context.vcsunknown:
                fg = 100
            elif context.vcsstaged:
                fg = 100
                attr |= bold
            elif context.vcssync:
                fg = 100
            elif context.vcsbehind:
                fg = 130
            elif context.vcsahead:
                fg = 24
            elif context.vcsdiverged:
                fg = 88
                attr |= bold
            elif context.vcsnone:
                fg = 243
            else:
                fg = 243
        elif context.vcsfile and context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 88
            elif context.vcschanged:
                fg = 130
            elif context.vcsunknown:
                fg = 100
            elif context.vcsstaged:
                fg = 100
                attr |= bold
            elif context.vcssync:
                fg = 100
            elif context.vcsbehind:
                fg = 130
            elif context.vcsahead:
                fg = 24
            elif context.vcsdiverged:
                fg = 88
                attr |= bold
            elif context.vcsnone:
                fg = 243
            else:
                fg = 243

        return (fg, bg, attr)
